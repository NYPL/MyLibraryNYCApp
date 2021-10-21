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
import TeacherSetDetails from "../components/TeacherSetDetails";
import TeacherSetOrder from "../components/TeacherSetOrder";
import CancelTeacherSetOrder from "../components/CancelTeacherSetOrder";



//import Footer from "./footer";

import { Link } from '@nypl/design-system-react-components';


export default class Routes extends React.Component {

  constructor(props) {
    super(props);
    this.state = { hold: "", teacher_set: "" }
    this.handleTeacherSetOrderedData = this.handleTeacherSetOrderedData.bind(this);

  }

  handleTeacherSetOrderedData(hold, teacher_set) {
    this.setState({ hold: hold, teacher_set: teacher_set })
  }

  render() {
    return (
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
            <Route path="/teacher_set_data" component={SearchTeacherSets} />
            <Route path="/secondary_menu" component={ContactsFaqsSchoolsNavMenu} />
            <Route
              path='/teacher_set_details/:id'
              render={routeProps => (
                <TeacherSetDetails {...routeProps} handleTeacherSetOrderedData={this.handleTeacherSetOrderedData} />
              )}
            />
            <Route
              path='/ordered_holds/:access_key'
              render={routeProps => (
                <TeacherSetOrder {...routeProps} holddetails={this.state.hold} teachersetdetails={this.state.teacher_set} />
              )}
            />
            <Route path="/holds/:id/cancel" component={CancelTeacherSetOrder} />
          </Switch>
          <footer className="footer">
            <Footer />
          </footer>
        </div>
      </Router>
  )
}
}