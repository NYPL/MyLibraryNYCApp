import React from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';

const ParticipatingSchools = (props) => {
  const state = {
    schools: []
  }

    axios.get('/schools')
    .then( (data) => {
        schools: [...data.data.schools]
    })
    .catch( (err) => console.log(err))


  return (
    <div>
      <AppBreadcrumbs />
      <h1 className="pg--title">ParticipatingSchools</h1>
  		<div className="pg--content">
  			ParticipatingSchools

  		</div>
    </div>
  );
    
}




export default ParticipatingSchools;