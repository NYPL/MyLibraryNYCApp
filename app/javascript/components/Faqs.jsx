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
      // const clicked = [...prevState.clicked]; // <- if clicked is declared as an array
      const clicked = { ...prevState.clicked };
      console.log(`prevState.clicked, clicked`, prevState.clicked, clicked);
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
        console.log("asdfasdfasd sdjfsd ")
    })
  }


  FrequentlyAskedQuestions() {    
      return this.state.faqs.map((data, i) => {
        return <table>
        <tbody>
            <tr>
              <td> 
               <h3>
                  <div key={data["id"]} onClick={() => this.handleClick(i)} className={this.state.clicked[i] ? 'expanded' : 'collapsed'}>
                      {data["question"]}
                  </div>
                </h3>

                <div className={this.state.clicked[i] ? 'display_block slide-down' : 'display_none slide-up'}>
                  {data["answer"]}
                </div>
              </td>
            </tr>
          </tbody>
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
