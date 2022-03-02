import React, { Component, useState } from 'react';

import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import {
  Input, TextInput, List, Form, Button, FormRow, InputTypes, ButtonTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select, Heading, HeadingLevels, Link, LinkTypes
} from '@nypl/design-system-react-components';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";


class AccountDetailsSubMenu extends Component {
  render() {
    return (
      <ul className="nav__submenu">
        <li className="nav__submenu-item ">
          <a>Our Company</a>
        </li>
        <li className="nav__submenu-item ">
          <a>Our Team</a>
        </li>
        <li className="nav__submenu-item ">
          <a>Our Portfolio</a>
        </li>
      </ul>
    )
  }
}

// ReactDOM.render(
//   <Menu />,
//   document.getElementById("account-menu-container")
// );