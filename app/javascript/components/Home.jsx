import React, {useEffect, useState } from 'react';
import HaveQuestions from "./HaveQuestions";
import AccessDigitalResources from "./AccessDigitalResources";
import CalendarOfEvents from "./CalendarOfEvents";
import NewsLetter from "./NewsLetter";
import homeBgImg from '../images/mln-homepage-background.jpg'
import homeFgImg from '../images/mln-homepage-foreground.jpg'
import { useNavigate } from "react-router-dom";
import { Hero, SearchBar, Icon, HorizontalRule, Heading, TemplateAppContainer, Notification, Text, Link } from '@nypl/design-system-react-components'; 

export default function Home(props) {
  const navigate = useNavigate();
  const [keyword, setKeyWord] = useState("")

  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  const handleSubmit = event => {
    event.preventDefault();

    if (keyword !== "") {
      navigate({
        pathname: '/teacher_set_data',
        search: '?keyword=' + keyword,
      });

    } else {
      navigate("/teacher_set_data")
    }
  }

  const handleSearchKeyword = event => {
    setKeyWord(event.target.value)
  }

  const SignedUpMessage = () => {
    if (!props.hideSignOutMsg && !props.userSignedIn && props.signoutMsg !== "") {
      return <Notification marginTop="l" icon={<Icon name="alertWarningFilled" color="ui.warning.primary" />} ariaLabel="SignOut Notification" id="sign-out-notification" notificationType="announcement" 
      notificationContent={<><b>You have been signed out.</b> You will need to <Link href="/signin">sign in</Link> again to access your account details.</>} />
    } else {
      return <></>
    }
  }

  return (
    <TemplateAppContainer
      breakout={<>
                <Hero heroType="campaign" 
                      heading={<Heading level="one"
                      id="mln-campaign-hero" text="Welcome To MyLibrary NYC" />} 
                      subHeaderText="We provide participating schools with enhanced library privileges including fine-free student and educator library cards, school delivery and the exclusive use of 6,000+ Teacher Sets designed for educator use in the classroom; and student and educator access to the unparalleled digital resources of New York City's public library systems as well as instructional support and professional development opportunities." 
                      backgroundImageSrc={homeBgImg}
                      imageProps={{alt: "Book highlights from MyLibrary NYC", src: homeFgImg, id: "mln-hero-image"}}
                      backgroundColor="var(--nypl-colors-brand-primary)"
                      /></>}
      contentTop={SignedUpMessage()}
      contentPrimary={
            <>
              <Heading id="search-for-home-page-teacher-sets" size="secondary">Search For Teacher Sets</Heading>
              <SearchBar id="home-page-teacher-set-search" labelText="home-page-teacher-set-search-label" noBrandButtonType onSubmit={handleSubmit} textInputProps={{ labelText: "Teacherset Search label", name: "teacherSetInputName", placeholder: "Enter teacher-set",  onChange: handleSearchKeyword}} />
              <HorizontalRule marginTop="l" id="home-horizontal-2" align="left" height="2px" />
              <Heading id="professional-heading" marginTop="s" size="secondary">Professional Development & Exclusive Programs</Heading>
              <Text noSpace marginTop="s" size="default">
                MyLibraryNYC educators can participate in workshops on a wide variety of subjects, aligned to New York State's Learning Standards to encourage reading and learning. From author talks to school programs, participating MyLibraryNYC schools can access a range of exciting programming.
              </Text>
              <CalendarOfEvents />
              <HorizontalRule marginTop="l" id="home-horizontal-3" align="left" height="2px" />
              <AccessDigitalResources />
            </>
          }
      contentBottom={<NewsLetter />}
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  )
}
