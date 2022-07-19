import React from 'react';
import { Link as ReactRouterLink } from "react-router-dom";
import { Link, Icon, List, Image, Flex, Spacer, HStack} from "@nypl/design-system-react-components";
import mlnLogoRed from '../images/MyLibrary_NYC_Red.png'
import Vector from '../images/Vector.png'

import AccountDetailsSubMenu from "./AccountDetailsSubMenu";


export default class Navbar extends React.Component {

  constructor(props) {
    super(props);
  }

  redirectToHome = () => {
   const { history } = this.props;
   if(history) history.push({ pathname: '/' });
  }

  hideHomeSignUpMsg = () => {
    this.props.hideSignUpMessage(true)
    this.redirectToHome()
  }

  redirectToTeacherSetPage = () => {
    const { history } = this.props;
    if(history) history.push({ pathname: '/teacher_set_data' });
  }

  hideSignInMsg = () => {
    this.props.hideSignInMessage(true)
    this.redirectToTeacherSetPage()
  }

  render() {
    return (
      <div id="mln-navbar" className="header-topWrapper">
        <Flex alignItems="center">

          <ReactRouterLink to="/" onClick={this.hideHomeSignUpMsg}>
            <Image id="mln-header-logo" marginLeft="m" style={{"color": "purple"}} alt="Alt text" className="header-logo" additionalImageStyles={{ "background-color": "var(--nypl-colors-ui-white)", "margin-left": "35px" }} size="small" src={mlnLogoRed} />
            <Image id="mln-header-logo" marginLeft="m" alt="Alt text" className="header-logo" additionalImageStyles={{ "background-color": "var(--nypl-colors-ui-white)", "margin-left": "35px" }} size="small" src={Vector} />
          </ReactRouterLink>

          <Spacer />
          <List id="mln-navbar-list" type="ul" inline noStyling>
            <HStack spacing="m">
              <li id="mln-navbar-ts-link"><ReactRouterLink to="/teacher_set_data" onClick={this.hideSignInMsg} className="nav-link-colors">Search Teacher Sets</ReactRouterLink></li>

              <li id="mln-navbar-contacts-link"><ReactRouterLink to="/contacts" className="nav-link-colors">Contact</ReactRouterLink></li>

              <li id="mln-navbar-faq-link"><ReactRouterLink to="/faq" className="nav-link-colors">FAQ</ReactRouterLink></li>

              <li id="mln-navbar-ps-link"><ReactRouterLink to="/participating-schools" className="nav-link-colors">Participating Schools</ReactRouterLink></li>

              <li id="mln-navbar-ad-link" className="nav__menu-item">
                <AccountDetailsSubMenu userSignedIn={this.props.userSignedIn} handleSignOutMsg={this.props.handleSignOutMsg} hideSignUpMessage={this.props.hideSignUpMessage} />
              </li>

              <li id="mln-navbar-social-media-link" className="nav__menu-item nav-link-colors socialMediaIcon">
                <Link type="action" target="_blank" href="https://twitter.com/mylibrarynyc/">
                  <Icon align="right" color="ui.black" className="navBarIcon" decorative iconRotation="rotate0" id="icon-id" name="socialTwitter" size="medium" type="default" />
                </Link>
                
                <Link type="action" target="_blank" href="https://www.instagram.com/mylibrarynyc/">
                  <Icon align="right" color="ui.black" className="navBarIcon" decorative iconRotation="rotate0" id="icon-id" name="socialInstagram" size="medium" type="default" />
                </Link>
              </li>
            </HStack>
          </List>
        </Flex>
      </div>
    );
  }
}