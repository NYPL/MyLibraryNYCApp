import React from "react";
import { NavLink } from "react-router-dom";
import Navbar from "./Navbar";

function AlertMessage() {
  return (
    <div className="app-alert">
      <div className="app-alert-message">
        We are now accepting teacher set returns. Teacher set deliveries are still currently suspended. Please email help@mylibrarynyc.org for all general questions and delivery@mylibrarynyc.org for all delivery questions.
      </div>
    </div>
  );
}

export default AlertMessage;
