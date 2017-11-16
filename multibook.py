from websocket_server import WebsocketServer
import time
import json
import Queue

class ShareMenu:
    def __init__(self, uuid):
        self.uuid = uuid
        self.queue = Queue.Queue()
        self.clients = []
        self.create_on = time.time()

    def add_client(self, client):
        self.clients.append(client)

    def del_client(self, client):
        print("del client %d from sharemenu" % client['id'])
        for c in self.clients:
            if c['id'] == client['id']:
                self.clients.remove(c)

    def add_change(self, msg):
        self.queue.put(msg)

    def notify(self, server):
        print json.loads('{"action":"data","uuid":"123","data":{"add":[1,2],"del":[10,11]}}')
        while not self.queue.empty():
            msg = self.queue.get()
            for client in self.clients:
                print("send to client id "+str(client['id']))
                try:
                    server.send_message(client, json.dumps(msg))
                except:
                    continue

share_menus = {}
max_connections = 1000
id2uuid = {}

def public(client, uuid):
    if uuid not in share_menus:
        share_menus[uuid] = ShareMenu(uuid)
        share_menus[uuid].add_client(client)
    else:
        print("id exists")

def subscribe(client, uuid):
    if uuid in share_menus:
        share_menus[uuid].add_client(client)
    else:
        print("not public")

def new_client(client, server):
    print("New client connected and was given id %d" % client['id'])
    #server.send_message_to_all("Hey all, a new client has joined us")

def client_left(client, server):
    if client['id'] not in id2uuid:
        return
    uuid = id2uuid[client['id']]
    if uuid in share_menus:
        share_menus[uuid].del_client(client)
        if len(share_menus[uuid].clients) <= 0:
            del share_menus[uuid]
    del id2uuid[client['id']]
    print("Client(%d) disconnected" % client['id'])


def message_received(client, server, message):
    print message
    msg = json.loads(message)
    if msg['action'] == 'pub':
        " { 'action' : 'pub', 'uuid' : uuid }"
        public(client, msg['uuid'])
        " { 'action' : 'sub', 'uuid' : uuid }"
    elif msg['action'] == 'sub':
        subscribe(client, msg['uuid'])
    elif msg['action'] == 'data':
        uuid = msg['uuid']
        if uuid in share_menus:
            share_menus[uuid].add_change(msg['data'])
            share_menus[uuid].notify(server)
        return
    id2uuid[client['id']] = msg['uuid']
    server.send_message(client, json.dumps({ 'code':0, 'message':'ok' }))

server = WebsocketServer(host = '0.0.0.0', port = 9001)
server.set_fn_new_client(new_client)
server.set_fn_client_left(client_left)
server.set_fn_message_received(message_received)
server.run_forever()
