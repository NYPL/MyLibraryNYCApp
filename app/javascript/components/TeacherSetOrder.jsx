import React, { useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import TeacherSetOrderDetails from "./TeacherSetOrderDetails";
import axios from 'axios';
import { useParams, useNavigate } from "react-router-dom";

import { Button, Heading, Link, Icon, TemplateAppContainer, HorizontalRule
} from '@nypl/design-system-react-components';

export default function TeacherSetOrder(props) {

  // constructor(props) {
  //   super(props);
  //   state = { access_key: this.props.match.params.access_key, 
  //                  hold: this.props.holddetails, 
  //                  teacher_set: this.props.teachersetdetails, status_label: this.props.statusLabel };
  // }
  const params = useParams();
  const navigate = useNavigate();
  const [access_key, setAccessKey] = useState(params["access_key"])
  const [hold, setHold] = useState(props.holddetails)
  const [teacher_set, setTeacherSet] = useState(props.teachersetdetails)
  const [status_label, setStatusLabel] = useState(props.statusLabel)

  useEffect(() => {
    if (typeof hold === 'string') {
      axios.get('/holds/' + params["access_key"])
        .then((res) => {
          if (res.request.responseURL == "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
            //window.location = res.request.responseURL;
            navigate(res.request.responseURL)
            return false;
          } else {
            setTeacherSet(res.data.teacher_set)
            setHold(res.data.hold)
            setStatusLabel(res.data.status_label)
          }
      })
      .catch(function (error) {
        console.log(error); 
      })
    }
  }, []);

  const TeacherSetTitle = () => {
    return <div>{teacher_set["title"]}</div>
  }

  const TeacherSetDescription = () => {
    return <div>{teacher_set["description"]}</div>
  }

  const OrderMessage = () => {
    const order_message = "Your order has been received by our system and will be soon delivered to your school. Check your email inbox for further details." 
    const cancelled_message = "The order below has been cancelled."
    return hold && hold["status"] == 'cancelled' ? cancelled_message : order_message
  }

  const showCancelButton = () => {
    return hold && hold.status == 'cancelled' ? 'none' : 'block'
  }

  const CancelButton = () => {
    return <div style={{ display: showCancelButton() }}>
      <Button id="order-cancel-button" className="cancel-button" buttonType="secondary" onClick={ () => window.scrollTo({ top: 10 })}>
        <Link className="cancelOrderButton" href={"/holds/" + params["access_key"] + "/cancel"} > Cancel My Order </Link>
      </Button>
    </div>
  }

  const confirmationMsg = () => {
    return (hold && hold.status === 'cancelled') ? 'Cancel Order Confirmation' : 'Order Confirmation'
  }
  
  return (
      <TemplateAppContainer
        breakout={<AppBreadcrumbs />}
        contentPrimary={
          <>
            <Heading id="order-confirmation-heading" level="two" size="secondary" text={confirmationMsg} />
            <HorizontalRule id="ts-detail-page-horizontal-rulel" className="teacherSetHorizontal" />
            { OrderMessage() }
            <TeacherSetOrderDetails  teacherSetDetails={teacher_set} orderDetails={hold}/>
            
            { CancelButton() }

            <Link  marginTop="l" href="/teacher_set_data" id="ts-details-link-page" type="action">
              <Icon name="arrow" iconRotation="rotate90" size="small" align="left" />
              Back to Search Teacher Sets Page
            </Link>
          </>
        }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
)}
