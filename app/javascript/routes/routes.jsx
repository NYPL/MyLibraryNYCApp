import React from "react";
import ReactDOM from "react-dom";
import { Route, BrowserRouter as Router, Switch , Redirect} from "react-router-dom";

import Header from "../components/Header";
import Footer from "../components/Footer";
import Home from "../components/Home";
import Faqs from "../components/Faqs";
import Navbar from "../components/Navbar";
import Contacts from "../components/Contacts";
import Banner from "../components/Banner";
import ParticipatingSchools from "../components/ParticipatingSchools";
import AppBreadcrumbs from "../components/AppBreadcrumbs";
import SignIn from "../components/SignIn";
import CalendarOfEvents from "../components/CalendarOfEvents";
import SearchTeacherSets from "../components/SearchTeacherSets";
import Accounts from "../components/Accounts";
import ContactsFaqsSchoolsNavMenu from "../components/ContactsFaqsSchoolsNavMenu";


//import Footer from "./footer";

import { Link } from '@nypl/design-system-react-components';


export default (
  <Router>
    <div className="layout-container nypl-ds">
      <header className="header">
        <Banner />
        <Header />
      </header>
      <Switch>
        <Route exact path="/" component={Home} />
        <Route path="/faq" component={Faqs} />
        <Route path="/contacts" component={Contacts} />
        <Route path="/participating-schools" component={ParticipatingSchools}  />
        <Route path="/users/start" component={SignIn} />
        <Route path="/teacher_set_data" component={SearchTeacherSets}/>
        <Route path="/secondary_menu" component={ContactsFaqsSchoolsNavMenu}/>

      </Switch>
      <footer className="footer">
        <Footer />
      </footer>
    </div>
  </Router>
);