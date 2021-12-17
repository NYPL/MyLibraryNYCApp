import React from "react";
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
import TeacherSetBooks from "../components/TeacherSetBooks";
import { render } from "react-dom";
import { DSProvider, TemplateAppContainer } from '@nypl/design-system-react-components';


export default class Routes extends React.Component {

  constructor(props) {
    super(props);
    this.state = { hold: "", teacher_set: "", userSignedIn: this.props.userSignedIn}
    this.handleTeacherSetOrderedData = this.handleTeacherSetOrderedData.bind(this);
  }

  handleTeacherSetOrderedData(hold, teacher_set, status_label) {
    this.setState({ hold: hold, teacher_set: teacher_set, status_label: status_label })
  }

  render() {
    return (
      <DSProvider>
        <TemplateAppContainer
        contentPrimary={
          <Router>
            <div className="layout-container nypl-ds">
              <header className="header">
                <Banner />
                <Header userSignedIn={this.state.userSignedIn}/>
              </header>
              <Switch>
                <Route exact path="/" component={Home} />
                <Route path="/faq" component={Faqs} />
                <Route path="/contacts" component={Contacts} />
                <Route path="/participating-schools" component={ParticipatingSchools}  />
                <Route path="/users/start" component={SignIn} />
                <Route path="/teacher_set_data" name="Teacher Sets" component={SearchTeacherSets} />
                <Route path="/secondary_menu" component={ContactsFaqsSchoolsNavMenu} />
                <Route path="/account" component={Accounts} />
                <Route
                  path='/teacher_set_details/:id'
                  render={routeProps => (
                    <TeacherSetDetails {...routeProps} handleTeacherSetOrderedData={this.handleTeacherSetOrderedData} />
                  )}
                />
                <Route
                  path='/ordered_holds/:access_key'
                  render={routeProps => (
                    <TeacherSetOrder {...routeProps} holddetails={this.state.hold} teachersetdetails={this.state.teacher_set} statusLabel={this.state.status_label} />
                  )}
                />
                <Route path="/holds/:id/cancel" component={CancelTeacherSetOrder} />
                <Route path="/book_details/:id" component={TeacherSetBooks} />
              </Switch>
            </div>
          </Router>
        }

        footer={<footer className="footer"> <Footer /></footer>}

        />
      </DSProvider>
    )
  }
}