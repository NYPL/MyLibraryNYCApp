import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";

import axios from 'axios';
import { Accordion, Link, List, DSProvider, TemplateAppContainer, VStack } from '@nypl/design-system-react-components';


export default function Faqs() {

  const [faqs, setFaqs] = useState([])

  React.useEffect(() => {
    axios.get('/faqs/show').then((response) => {
      setFaqs(response.data.faqs);
    }).catch(function (error) {
    })
  }, []);


  if (!faqs) return null;


  function FrequentlyAskedQuestions() {
    return faqs.map((data, i) => {
      return <Accordion id={"faqs-page-"+ i} accordionData={[ { "label": data["question"], "panel": data["answer"] } ]} />
    })
  }

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={FrequentlyAskedQuestions()}
      contentSidebar={<div className="have_questions_section"><HaveQuestions /></div>}
      sidebar="right"
    />
  )
}