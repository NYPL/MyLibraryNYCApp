class Menu extends React.Component {  
  render() {
    return (
      <nav className="nav">
        <ul className="nav__menu">
          <li className="nav__menu-item">
            <a>Home</a>
          </li>
          <li
            className="nav__menu-item"
          >
            <a>About</a>
            <Submenu />
          </li>
          <li className="nav__menu-item">
            <a>Contact</a>
          </li>
        </ul>
      </nav>
    )
  }
}

class Submenu extends React.Component {
  render() {
    return (
      <ul className="nav__submenu">
        <li className="nav__submenu-item">
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

ReactDOM.render(
  <Menu />,
  document.getElementById("menu-container")
);



/*
This is the extracted copied part responsible for showing & hiding the submenu.
*/

.nav__submenu {
  display: none;
}

.nav__menu-item:hover {
  .nav__submenu {
    display: block;
  }
}

/*
Layout styles.

I like to work on stuff that's good looking so I remixed a cool simple menu by Mike Rojas (thanks!): https://codepen.io/mikerojas87/pen/rojKb 
*/

$color-blue: #00aeef;
$color-blue-dark: #0d2035;
$submenu-width: 180px;


html {
  box-sizing: border-box;
}

*, *:before, *:after {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: 'Open Sans', sans-serif;
  font-size: 16px;
  line-height: 1.5;
}

.menu-container {
  text-align: center;
}

nav {
  ul {
    list-style: none;
    padding-left: 0;
    margin-top: 0;
    margin-bottom: 0;
  }
}

.nav {
  display: inline-block;
  margin: 2rem auto 0;
  background: $color-blue-dark;
  color: #fff;
  text-align: left;
  
  a {
    display: block;
    padding: 0 16px;
    line-height: inherit;
    cursor: pointer;
  }
}
  
.nav__menu {
  line-height: 45px;
  font-weight: 700;
  text-transform: uppercase;
}
  
.nav__menu-item {
  display: inline-block;
  position: relative;

  &:hover {
    background-color: $color-blue;

    .nav__submenu {
      display: block;
    }
  }
}
    
.nav__submenu {
  font-weight: 300;
  text-transform: none;
  display: none;
  position: absolute;
  width: $submenu-width;
  background-color: $color-blue;
}
    
.nav__submenu-item {
  &:hover {
    background: rgba(#000, 0.1);
  }
}