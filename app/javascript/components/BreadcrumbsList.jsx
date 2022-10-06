import React from "react";

const BreadcrumbsList = (levelString) => {
  switch (levelString) {
    case 'participating-schools':
      return 'Participating schools';
    case 'faq':
      return 'Frequently Asked Questions';
    case 'critical':
      return 2;
    case 'error':
      return 3;
    case 'warning':
      return 4;
    case 'notice':
      return 5;
    case 'info':
      return 6;
    case 'debug':
      return 7;
    default:
      return 'n/a';
  }
};


export default BreadcrumbsList;