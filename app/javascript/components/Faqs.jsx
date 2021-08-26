import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import { Accordion, Link, List } from '@nypl/design-system-react-components';

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
        return <List modifiers={['no-list-styling' ]} type="ul">
          <li>
          <Accordion
            accordionLabel={data["question"]}
            inputId={"accordionBtn-" + i}
            modifiers={[
              'faq'
            ]}
          >
            <React.Fragment key=".{i}">
              <p>
                {data["answer"]}
              </p>
            </React.Fragment>
          </Accordion>
        </li>
      </List>
    })
  }


  render() {
    return (
      <>
        <AppBreadcrumbs />
        <main className="main main--with-sidebar nypl-ds">
          <div className="content-primary content-primary--with-sidebar-right">
            <div className="faq_list nypl-ds">
              {this.FrequentlyAskedQuestions()}
            </div>
          </div>

          <div className="content-secondary content-secondary--with-sidebar-right">
            
          </div>
        </main>
      </>
    )
  }
}
