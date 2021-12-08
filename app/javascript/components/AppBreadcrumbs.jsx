import React, { Component, useState } from 'react';
import PropTypes from 'prop-types';

import {
  Breadcrumbs,
  Heading,
  SearchBar,
  Select,
  Button,
  ButtonTypes,
  Hero, DSProvider, ColorVariants, colorVariant, HeroTypes, HeadingLevels
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
    return (
      <>
        <>
          <Breadcrumbs breadcrumbsData={ [
            { url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" },
            { url: "//"+ window.location.hostname + window.location.pathname, text: BreadcrumbsDataValue(window.location.href.split('/')[3]) } 
           ] } 
            colorVariant="booksAndMore"
          />
          <Hero heroType="tertiary"
                backgroundColor="var(--nypl-colors-brand-primary)"
                heading={<Heading level={HeadingLevels.One} id="books-hero" text={BreadcrumbsDataValue(window.location.href.split('/')[3])} />} />

        </>

      </>
    )
  }
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
      return 'Teacher Set Order Details';
    case 'ordered_holds':
      return 'Teacher Set Order';
    case 'holds':
      return 'Cancel Order';
    case 'account':
      return 'Accounts page';
    default:
      return levelString;
  }
};