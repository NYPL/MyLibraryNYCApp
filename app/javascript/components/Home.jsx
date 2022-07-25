import React from 'react';
import HaveQuestions from "./HaveQuestions";
import AccessDigitalResources from "./AccessDigitalResources";
import CalendarOfEvents from "./CalendarOfEvents";
import NewsLetter from "./NewsLetter";
import heroCampaignBg from '../images/hero_campaign_bg.jpg'
import heroCampaignLeft from '../images/hero_campaign_left.jpg'
import axios from 'axios';
import { Hero, SearchBar, Icon, HorizontalRule, Heading, TemplateAppContainer, Notification, Text, Link } from '@nypl/design-system-react-components';

export default class Home extends React.Component {

  constructor(props) {
    super(props);
    this.state = { userSignedIn: this.props.userSignedIn, teacherSets: [], email: "",
                   pagination: "", keyword: new URLSearchParams(this.props.location.search).get('keyword') };
  }

  componentDidMount() {
    if (this.state.keyword !== "" ) {
      this.getTeacherSets()
    }
  }

  getTeacherSets() {
    axios.get('/teacher_sets', {
        params: {
          keyword: this.state.keyword
        }
     }).then(res => {
        this.setState({ teacherSets: res.data.teacher_sets });
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  handleSubmit = event => {
    event.preventDefault();
    if (this.state.keyword !== null) {
      this.props.history.push("/teacher_set_data"+ "?keyword=" + this.state.keyword)
    } else {
      this.props.history.push("/teacher_set_data")
    }
    this.getTeacherSets()
  }

  handleSearchKeyword = event => {
    this.setState({ 
      keyword: event.target.value
    })
  }

  SignedUpMessage() {
    if (!this.props.hideSignOutMsg && !this.props.userSignedIn && this.props.signoutMsg !== "") {
      return <Notification marginTop="l" icon={<Icon name="alertNotificationImportant" color="section.locations.primary" />} ariaLabel="SignOut Notification" id="sign-out-notification" notificationType="announcement" 
      notificationContent={<><b>You have been signed out.</b> You will need to <Link href="/signin">sign in</Link> again to access your account details.</>} />
    } else {
      return <></>
    }
  }

  render() {
    return (
      <TemplateAppContainer
        breakout={<>
                  <Hero heroType="campaign" 
                        heading={<Heading level="one"
                        id="mln-campaign-hero" text="Welcome To MyLibrary NYC" />} 
                        subHeaderText="We provide participating schools with enhanced library privileges including fine-free student and educator library cards, school delivery and the exclusive use of 6,000+ Teacher Sets designed for educator use in the classroom; and student and educator access to the unparalleled digital resources of New York City's public library systems as well as instructional support and professional development opportunities." 
                        backgroundImageSrc={heroCampaignBg}
                        imageProps={{alt: "Mln hero image", src: heroCampaignLeft, id: "mln-hero-image"}}
                        /></>}
        contentTop={this.SignedUpMessage()}
        contentPrimary={
              <>
                <Heading id="search-for-home-page-teacher-sets" level="two">Search For Teacher Sets</Heading>
                <SearchBar id="home-page-teacher-set-search" labelText="home-page-teacher-set-search-label" noBrandButtonType onSubmit={this.handleSubmit} textInputProps={{ labelText: "Teacherset Search label", name: "teacherSetInputName", placeholder: "Enter teacher-set",  onChange: this.handleSearchKeyword}} />{<br/>}
                <HorizontalRule id="home-horizontal-2" align="left" height="3px" />
                <Heading id="professional-heading" level="three">Professional Development & Exclusive Programs</Heading>
                <Text size="default">
                  MyLibraryNYC educators can participate in workshops on a wide variety of subjects, aligned to New York State's Learning Standards to encourage reading and learning. From author talks to school programs, participating MyLibraryNYC schools can access a range of exciting programming.
                </Text>
                <CalendarOfEvents />
                <HorizontalRule id="home-horizontal-3" align="left" height="3px" />
                <AccessDigitalResources />
              </>
            }
        contentSidebar={<HaveQuestions />}
        sidebar="right"
        footer={<NewsLetter />}
      />
    )
  }
}
