import { Layout } from "antd";
import React from "react";
import Header from "./Header";
import Footer from "./Footer";

const { Content } = Layout;

export default () => (
	<Layout className="layout">
		<Content style={{ padding: "0 50px" }}>
			<div className="site-layout-content" style={{ margin: "100px auto" }}>
				<h1>Home page</h1>
			</div>
		</Content>
	</Layout>
);
