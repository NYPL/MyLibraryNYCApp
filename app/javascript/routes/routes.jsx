import React from "react";
import ReactDOM from "react-dom";
import { Route, BrowserRouter as Router, Switch } from "react-router-dom";

import Header from "../components/Header";
import Footer from "../components/Footer";
import Faq from "../components/Faq";
import Navbar from "../components/Navbar";
import Contacts from "../components/Contacts";
import AlertMessage from "../components/AlertMessage";
import ParticipatingSchools from "../components/ParticipatingSchools";
import SignIn from "../components/SignIn";


//import Footer from "./footer";

import { Link } from '@nypl/design-system-react-components';


export default (
  <Router>
    <div>
      <AlertMessage />
      <div className="mainContent">
        <Header />
        <Switch>
          <Route path="/faq" component={Faq} />
          <Route path="/help" component={Contacts} />
          <Route path="/participating-schools" component={ParticipatingSchools} />
          <Route path="/users/start" component={SignIn} />
        </Switch>
        <Footer />
      </div>
    </div>
  </Router>
);