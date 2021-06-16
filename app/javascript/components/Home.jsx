import { Layout } from "antd";
import React from "react";
import Header from "./Header";
import Footer from "./Footer";

const { Content } = Layout;

export default () => (
	<Layout className="layout">
		<Header />
		<Content style={{ padding: "0 50px" }}>
			<div className="site-layout-content" style={{ margin: "100px auto" }}>
				<h1>Beer's Catalog</h1>
			</div>
		</Content>
		<Footer />
	</Layout>
);
