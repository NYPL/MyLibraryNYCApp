import React, { Component, useState } from 'react';
import PropTypes from 'prop-types';

import {
  Breadcrumbs,
  Heading,
  SearchBar,
  Select,
  Button,
  Hero, DSProvider, ColorVariants, colorVariant,
} from '@nypl/design-system-react-components';

import "../styles/application.scss"

let breadcrumbs_text;
let path_url;
import BreadcrumbsList from "./BreadcrumbsList";



export default class AppBreadcrumbs extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    let location_path = window.location.pathname.split(/\/|\?|&|=|\./g)[1]

    return (
      <>
        <Breadcrumbs id={"mln-breadcrumbs-"+location_path} breadcrumbsData={ breadcrumbsUrl(location_path) }
          breadcrumbsType="booksAndMore"
        />
        <Hero heroType="tertiary"
              backgroundColor="var(--nypl-colors-brand-primary)"
              heading={<Heading level="one" id={"hero-"+location_path} text={HeroDataValue(location_path)} />} />
      </>
    )
  }
}



const breadcrumbsUrl = (location_path) => {

  let urls = [{ url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" }]
  
    urls.push({ url: "//"+ window.location.hostname + window.location.pathname, text: HeroDataValue(location_path) })
  
  if (['signup', 'signin', 'ordered_holds', 'teacher_set_details', 'book_details'].includes(location_path)) {
    urls.push({ url: "//"+ window.location.hostname + window.location.pathname, text: BreadcrumbsDataValue(location_path) })
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
      return 'Cancel Order';
    case 'book_details':
      return 'Book Details';
    case 'signup':
      return 'SignUp';
    case 'signin':
      return 'SignIn';
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
      return 'Cancel Order';
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