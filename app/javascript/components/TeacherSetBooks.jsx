import PropTypes from 'prop-types';
import React, { Component, useState } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink} from "react-router-dom";
import axios from 'axios';
import {
  Button,
  ButtonTypes,
  SearchBar,
  Select,
  Input,
  SearchButton,
  Card,
  CardHeading,
  CardLayouts,
  CardContent,
  MDXCreateElement,
  Heading,
  Image,
  List, Link, LinkTypes, DSProvider, TemplateAppContainer, Text, Form, FormRow, FormField
} from '@nypl/design-system-react-components';

import TeacherSetOrder from "./TeacherSetOrder";

export default class TeacherSetBooks extends React.Component {

  constructor(props) {
    super(props);
    this.state = {book: "", teacher_sets: ""};
  }

  componentDidMount() {
    axios.get('/books/'+ this.props.match.params.id)
      .then(res => {
        this.setState({  
          book: res.data.book, teacher_sets: res.data.teacher_sets, 
        });
      })
      .catch(function (error) {
        console.log(error);
    })    
  }


  TeacherSets() {
    return this.state.teacher_sets.map((data, i) => {
      return <div>
        <ReactRouterLink to={"/book_details/" + data.id} >
          <Image imageSize="small" src={data.cover_uri} />
        </ReactRouterLink>
      </div>      
    })
  }


  render() {
    let book = this.state.book;
    let teacher_sets = this.state.teacher_sets

    return (
      <DSProvider>
        <TemplateAppContainer
          breakout={<AppBreadcrumbs />}
          contentPrimary={
            <>
              <Image imageSize="medium" src={book.cover_uri} />

              <div>
                <h2>{book.title}</h2>
                <h3>{book.sub_title}</h3>
                <h4>{book.statement_of_responsibility}</h4>
                <p>{book.description}</p>
              </div>

              <List type="dl">
                <dt className="font-weight-500 orderDetails">
                  Publication Date
                </dt>
                <dd className="orderDetails">
                  {book.publication_date}
                </dd>

                <dt className="font-weight-500 orderDetails">
                  Call Number
                </dt>
                <dd className="orderDetails">
                  {book.call_number}
                </dd>

                <dt className="font-weight-500 orderDetails">
                  Physical Description
                </dt>
                <dd className="orderDetails">
                  {book.physical_description}
                </dd>

                <dt className="font-weight-500 orderDetails">
                  Primary Language
                </dt>
                <dd className="orderDetails">
                  {book.primary_language}
                </dd>

                <dt className="font-weight-500 orderDetails">
                  ISBN
                </dt>
                <dd className="orderDetails">
                  {book.isbn}
                </dd>

                <dt className="font-weight-500 orderDetails">
                  Notes
                </dt>
                <dd className="orderDetails">
                  {book.notes}
                </dd>
              </List>
              <a target='_blank' href={book.details_url}>View in catalog</a>

              <h3>Appears in These Sets:</h3>

            </>
          }

          contentSidebar={<></>}
          sidebar="right"
        />
      </DSProvider>
    )
  }
}