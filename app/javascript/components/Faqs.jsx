import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import { Accordion, Link, List, DSProvider, TemplateAppContainer } from '@nypl/design-system-react-components';

export default class Faqs extends Component {

  constructor(props) {
    super(props);
    this.state = { faqs: [], collapsed: true, clicked: {} };
  }


  onToggle = () => {
    const { collapsed } = this.state;
    this.setState(() => ({
      collapsed : !collapsed
    }))
  }


  handleClick = i => {
    this.setState(prevState => {
      const clicked = { ...prevState.clicked };
      clicked[i] = !clicked[i];
      return { clicked };
    });
  };


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
          label: data["question"],
          panel: data["answer"]
        }
    })
  }


  render() {
    return (
      <>
        <AppBreadcrumbs />
        <DSProvider>
          <TemplateAppContainer
            breakout=""
            contentPrimary={
              <div className="faq_list nypl-ds">
                <Accordion contentData={this.FrequentlyAskedQuestions()} />
              </div>
            }
            contentSidebar=""
            sidebar="right" 
          />
        </DSProvider>
      </>
    )
  }
}
