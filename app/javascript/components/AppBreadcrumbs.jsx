import React from "react";
import {
  Breadcrumbs,
  Heading,
  SearchBar,
  Select,
  Button,
  ButtonTypes
} from '@nypl/design-system-react-components';

import "../styles/application.scss"

const AppBreadcrumbs = (props) => {
  return (
    <div>
      {console.log(props)}
      <Breadcrumbs
        breadcrumbs={[
          { url: 'https://www.nypl.org/', text: 'Home' },
          { url: 'https://www.nypl.org/research', text: 'Research' }
        ]}
        className="breadcrumbs"
      />
      
      <div className="breadcrumb-title-details">
        
      </div>
    </div>

  );
}

export default AppBreadcrumbs;