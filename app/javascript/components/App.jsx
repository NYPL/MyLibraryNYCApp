import React, { useState, useEffect } from "react";
import axios from "axios";
import AppRoutes from "../routes/AppRoutes";

export default function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    loginStatus();
  }, []);

  const handleLogin = () => {
    setIsLoggedIn(true);
  };

  const handleLogout = () => {
    setIsLoggedIn(false);
  };

  const loginStatus = () => {
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .get("/logged_in")
      .then((response) => {
        if (response.data.logged_in) {
          handleLogin();
        } else {
          handleLogout();
        }
      })
      .catch((error) => console.log("api errors:", error));
  };

  return (
    <AppRoutes userSignedIn={isLoggedIn} setUserSignedIn={setIsLoggedIn} />
  );
}
