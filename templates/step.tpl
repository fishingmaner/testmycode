<style type="text/css">

*, *:before, *:after {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

ul {list-style: none;}

.cf:before, .cf:after {
	content: ' ';
	display: table;
}
.cf:after {
	clear: both;
}

.title {
	padding: 50px 0;
	font: 24px 'Open Sans', sans-serif;
	text-align: center;
}



.inner {
	max-width: 820px;
	margin: 0 auto;
}
.breadcrumbs {
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ddd;
	background-color: #f5f5f5;
}
.breadcrumbs ul {
	border-left: 1px solid #ddd;
	border-right: 1px solid #ddd;
}
.breadcrumbs li {
	float: left;
	width: 25%;
}
.breadcrumbs a {
	position: relative;
	display: block;
	padding: 20px;
	padding-right: 0 !important;
	/* important overrides media queries */
	font-size: 13px;
	font-weight: bold;
	text-align: center;
	color: #aaa;
	cursor: pointer;
}

.breadcrumbs a:hover {
	background: #eee;
}
.breadcrumbs a.active {
	color: #777;
	background-color: #fafafa;
}
.breadcrumbs a span:first-child {
	display: inline-block;
	//width: 22px;
	height: 22px;
	padding: 2px;
	//margin-right: 5px;
	//border: 2px solid #aaa;
	//border-radius: 50%;
	//background-color: #fff;
}

.breadcrumbs a.active span:first-child {
	color: #fff;
	border-color: #777;
	background-color: #777;
}

.breadcrumbs a:before,
.breadcrumbs a:after {
	content: '';
	position: absolute;
	top: 0;
	left: 100%;
	z-index: 1;
	display: block;
	width: 0;
	height: 0;
	border-top: 32px solid transparent;
	border-bottom: 32px solid transparent;
	border-left: 16px solid transparent;
}

.breadcrumbs a:before {
	margin-left: 1px;
	border-left-color: #d5d5d5;
}
.breadcrumbs a:after {
	border-left-color: #f5f5f5;
}
.breadcrumbs a:hover:after {
	border-left-color: #eee;
}
.breadcrumbs a.active:after {
	border-left-color: #fafafa;
}
.breadcrumbs li:last-child a:before,
.breadcrumbs li:last-child a:after {
	display: none;
}

.breadcrumbs .current a:after {
	border-left-color: green;
}
li.current {
	background-color: green;
}
.current a {
    color:white;
}
.breadcrumbs .unstart a:after {
	border-left-color: white;
}
li.unstart {
	background-color: white;
}
.unstart a {
    color:black;
}

@media (max-width: 720px) {
	.breadcrumbs a {
		padding: 15px;
	}

	.breadcrumbs a:before,
	.breadcrumbs a:after {
		border-top-width: 26px;
		border-bottom-width: 26px;
		border-left-width: 13px;
	}
}
@media (max-width: 620px) {
	.breadcrumbs a {
		padding: 10px;
	}

	.breadcrumbs a:before,
	.breadcrumbs a:after {
		border-top-width: 22px;
		border-bottom-width: 22px;
		border-left-width: 11px;
	}
}
@media (max-width: 520px) {
	.breadcrumbs a {
		padding: 5px;
	}
	.breadcrumbs a:before,
	.breadcrumbs a:after {
		border-top-width: 16px;
		border-bottom-width: 16px;
		border-left-width: 8px;
	}
	.breadcrumbs li a span:first-child {
		display: block;
		margin: 0 auto;
	}
	.breadcrumbs li a span:last-child {
		//display: none;
	}
}
</style>
<div class='breadcrumbs'>
	<div class='inner'>
		<ul class='cf'>
			<li class="order"><a><span>下单</span></a></li>
			<li class="accept"><a><span>餐馆确认</span></a></li>
			<li class="pay"><a><span>支付</span></a></li>
			<li class="eat"><a><span>就餐</span></a></li>
		</ul>
	</div>
</div>
