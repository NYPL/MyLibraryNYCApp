import React from "react";
import ReactDOM from "react-dom";
import { Route, BrowserRouter as Router, Switch } from "react-router-dom";

import Header from "../components/Header";
import Footer from "../components/Footer";
import Faq from "../components/Faq";
import Navbar from "../components/Navbar";
// import App from "../components/App";

//import Footer from "./footer";

export default (
  <Router>
    <div>
      <Navbar />
      <hr />
        <Switch>
          <Route path="/faq" component={Faq} />
        </Switch>
      <Footer />
    </div>
  </Router>
);