import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import SignedInMsg from "./SignedInMsg";
import axios from 'axios';
import { Accordion, Link, List, DSProvider, TemplateAppContainer, SkeletonLoader } from '@nypl/design-system-react-components';
import HTMLReactParser from 'html-react-parser';

export default class Faqs extends Component {

  constructor(props) {
    super(props);
    this.state = { faqs: [] };
  }


  componentDidMount() {
    axios.get('/faqs/show')
      .then(res => {
        this.setState({ faqs: res.data.faqs });
      })
      .catch(function (error) {
    })
  }


  FrequentlyAskedQuestions() {
    return this.state.faqs.map((data, i) => {
      return {
        label: <div className="hrefLink">{HTMLReactParser(data["question"])}</div>,
        panel: <div className="hrefLink">{HTMLReactParser(data["answer"])}</div>
      }
    })
  }

  skeletonLoaderForFaqs() {
    if (this.state.faqs.length <= 0) {
      return <div width="900px"/>
    }
  }

  render() {
    return (
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentTop={<SignedInMsg signInDetails={this.props} />}
          contentPrimary={
            <>
              {this.skeletonLoaderForFaqs()}
              <Accordion id="faqs-page" accordionData={this.FrequentlyAskedQuestions()} />
            </>
            
          }
          contentSidebar={<div><HaveQuestions /></div>}
          sidebar="right"
        />
    )
  }
}
