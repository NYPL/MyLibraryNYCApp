import React, { Component } from 'react';
import { Breadcrumbs, Heading, Hero } from '@nypl/design-system-react-components';
import "../styles/application.scss"

export default class AppBreadcrumbs extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    let locationPath = window.location.pathname.split(/\/|\?|&|=|\./g)[1]

    return (
      <>
        <Breadcrumbs id={"mln-breadcrumbs-"+locationPath} breadcrumbsData={ breadcrumbsUrl(locationPath) }
          breadcrumbsType="booksAndMore"
        />
        <Hero heroType="tertiary"
              backgroundColor="var(--nypl-colors-brand-primary)"
              heading={<Heading level="one" id={"hero-"+locationPath} text={HeroDataValue(locationPath)} />} />
      </>
    )
  }
}

const breadcrumbsUrl = (locationPath) => {

  let urls = [{ url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" }]

  let locationPathname = window.location.pathname

  if (['ordered_holds', 'teacher_set_details', 'book_details'].includes(locationPath)) {
    locationPathname = '/teacher_set_data'
  } else if (['signup', 'signin'].includes(locationPath)) {
    locationPathname = '/account_details'
  }

  urls.push({ url: "//"+ window.location.hostname + locationPathname, text: HeroDataValue(locationPath) })

  if (['signup', 'signin', 'ordered_holds', 'teacher_set_details', 'book_details', 'holds'].includes(locationPath)) {
    urls.push({ url: "//"+ window.location.hostname + window.location.pathname, text: BreadcrumbsDataValue(locationPath) })
  }
  return urls;
}

const BreadcrumbsDataValue = (levelString) => {
  switch (levelString) {
    case 'participating-schools':
      return 'Participating schools';
    case 'faq':
      return 'Frequently Asked Questions';
    case 'contacts':
      return 'Contacts';
    case 'teacher_set_data':
      return 'Teacher Sets';
    case "teacher_set_details":
      return 'Teacher Sets';
    case 'ordered_holds':
      return 'Order Confirmation';
    case 'holds':
      return 'Order Confirmation';
    case 'book_details':
      return 'Book Details';
    case 'signup':
      return 'Sign Up';
    case 'signin':
      return 'Sign In';
    default:
      return levelString;
  }
};

const HeroDataValue = (levelString) => {
  switch (levelString) {
    case 'participating-schools':
      return 'Participating schools';
    case 'faq':
      return 'Frequently Asked Questions';
    case 'contacts':
      return 'Contacts';
    case 'teacher_set_data':
      return 'Teacher Sets';
    case "teacher_set_details":
      return 'Teacher Sets';
    case 'ordered_holds':
      return 'Teacher Sets';
    case 'holds':
      return 'Teacher Sets';
    case 'account_details':
      return 'My Account & Orders';
    case 'book_details':
      return 'Book Details';
    case 'signup':
      return 'Account';
    case 'signin':
      return 'Account';
    default:
      return levelString;
  }
}