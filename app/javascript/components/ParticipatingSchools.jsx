import React, { Component } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';




export default class ParticipatingSchools extends Component {

    constructor(props) {
      super(props);
      this.state = { usersCollection: [] };
    }

    componentDidMount() {
      axios.get('/schools')
        .then(res => {
          this.setState({ usersCollection: res.data.schools });
        })
        .catch(function (error) {
            console.log(error);
      })
    }


    Schools(){
      return this.state.usersCollection.map((data, i) => {
        return <ul>
            <li>{data['alphabet_anchor']}</li>
            {data['school_names'].map(item =>
              <li key="{item}">{item}</li>
            )}
          </ul>

      })
    }

    render() {
        return (
          <div>
            <AppBreadcrumbs />
            <div className="participating_schools_list">
              {this.Schools()}
            </div>
          </div>
        )
      }
}
