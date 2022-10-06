import React, { useContext, useState, useEffect }  from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from 'axios';
import { TemplateAppContainer, Text, Heading } from "@nypl/design-system-react-components";

const NewsletterConfirmation = () =>  {

  const [success, setSuccess] = useState(false)

  useEffect(() => {
    window.scrollTo(0, 0);
    axios.get('/home/newsletter_confirmation_msg')
      .then(res => {
        setSuccess(res.data.success);
      })
      .catch(function (error) {
       console.log(error);
    })

  }, []);


  const NewsletterConfirmationMsg = () => {
    if (success) {
      return <>
        <Text isBold size="default">MyLibraryNYC Newsletter Subscription Confirmed</Text>
        <Text>Thank you for subscribing to the MyLibraryNYC newsletter. Your email has been confirmed.</Text>
      </>
    } else {
      return <>
        <Text isBold size="default">MyLibraryNYC Newsletter Subscription Unsuccessful</Text>
        <Text>Unfortunately there was a problem subscribing to the MyLibraryNYC Newsletter. Please try subscribing again at <a href="https://www.mylibrarynyc.org/">www.mylibrarynyc.org</a> or contact <a href='mailto:help@mylibrarynyc.org'>help@mylibrarynyc.org</a>.</Text>
      </>

    }
  }

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentTop={NewsletterConfirmationMsg()}
    />
  )
}

export default NewsletterConfirmation;