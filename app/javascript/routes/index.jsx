import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Home from "../components/Home";
import Faq from "../components/Faq";
import Help from "../components/Help";

import Header from "../components/Header";

import Footer from "../components/Footer";


export default (
	<Router>
    <div>
      <Header />
      <hr />
      <Switch>
        <Route exact path="/" component={Home} />
        <Route path="/faq" component={Faq} />
        <Route path="/help" component={Help} />
      </Switch>
      <Footer />
    </div>
  </Router>
);



