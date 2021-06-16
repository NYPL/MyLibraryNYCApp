import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Home from "../components/Home";
import Faq from "../components/Faq";


export default (
	<Router>
		<Switch>
			<Route path="/" exact component={Home} />
			<Route path="/faq" exact component={Faq} />
		</Switch>
	</Router>
);
