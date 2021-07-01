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
            <li className="schoolList">{data['alphabet_anchor']}</li>
            {data['school_names'].map(item =>
              <li key="{item}">{item}<br/></li>
            )}

          </ul>

      })
    }

    render() {
        return (
          <div>
            <AppBreadcrumbs />
            <div className="participating_schools_list">
              <div className="participating_schools schoolList">Participating Schools</div>
              <div className="school_header schoolList">Does your school participate in MyLibraryNYC?</div>
              <div className="schoolList">Find your school using the following links:</div>
              <div className="schoolList">
                <a href="##">#</a> <a href="#A">A</a> <a href="#B">B</a> <a href="#C">C</a> <a href="#D">D</a> <a href="#E">E</a> <a href="#F">F</a> <a href="#G">G</a> <a href="#H">H</a> <a href="#I">I</a> <a href="#J">J</a> <a href="#K">K</a> <a href="#L">L</a> <a href="#M">M</a> <a href="#N">N</a> <a href="#O">O</a> <a href="#P">P</a> <a href="#Q">Q</a> <a href="#R">R</a> <a href="#S">S</a> <a href="#T">T</a> <a href="#U">U</a> <a href="#V">V</a> <a href="#W">W</a> <a href="#X">X</a> <a href="#Y">Y</a> <a href="#Z">Z</a>
              </div>
              <div>or type the name of your school in the box below</div>

              {this.Schools()}
            </div>
          </div>
        )
      }
}
