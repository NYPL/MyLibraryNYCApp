import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input,
  SearchBar,
  Select,
} from '@nypl/design-system-react-components';

export default class Faqs extends Component {

  constructor(props) {
    super(props);
    this.state = { faqs: [], collapsed: true };
  }


  onToggle = () => {
    const { collapsed } = this.state;
    this.setState(() => ({
      collapsed : !collapsed
    }))
  }


  componentDidMount() {
    axios.get('/faqs/show')
      .then(res => {
        this.setState({ faqs: res.data.faqs });
      })
      .catch(function (error) {
        console.log("asdfasdfasd sdjfsd ")
    })
  }


  FrequentlyAskedQuestions() {    
      return this.state.faqs.map(data => {
        const { collapsed } = this.state;
        return <table>
          <tr>
            <td> 
             <h3>
                <div  onClick={this.onToggle} className={collapsed ? 'expanded' : 'collapsed'}>
                  {data["question"]}
                </div>
              </h3>

              <div style={{display : collapsed ? 'none' :'block'}}>
                {data["answer"]}
              </div>
            </td>
          </tr>
        </table>
      })
  }


  render() {
    return (
      <div>
        <AppBreadcrumbs />
        <div className="participating_schools_list">
          {this.FrequentlyAskedQuestions()}
        </div>
      </div>
    )
  }
}
