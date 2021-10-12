import React, { Component, useState } from 'react';
import PropTypes from 'prop-types';

import {
  Breadcrumbs,
  Heading,
  SearchBar,
  Select,
  Button,
  ButtonTypes,
  Hero
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
      <div>
        <Breadcrumbs
          breadcrumbs={[
            { url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: 'Home' },
            { url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: BreadcrumbsData(window.location.href.split('/')[3]) }
          ]}
          className="breadcrumbs"
        />

        <Hero className=""
          backgroundColor="#D23B42"
          heading={<Heading blockName="hero" id="1" level={1} text={BreadcrumbsData(window.location.href.split('/')[3])} />}
          heroType="TERTIARY"
        />
      </div>
    )
  }
}


const BreadcrumbsData = (levelString) => {
  switch (levelString) {
    case 'participating-schools':
      return 'Participating schools';
    case 'faq':
      return 'Frequently Asked Questions';
    case 'help':
      return 'Contacts';
    case 'error':
      return 3;
    case 'warning':
      return 4;
    case 'notice':
      return 5;
    case 'info':
      return 6;
    case 'debug':
      return 7;
    default:
      return levelString;
  }
};