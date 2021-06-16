import React from "react";
import { Layout, Menu } from "antd";

const { Header } = Layout;


import {
  Button,
  ButtonTypes,
  Modal,
  Card,
} from '@nypl/design-system-react-components';


export default () => (
	<Header>
		<div className="header" style={{ align: "center" }}>
			This is Header
		</div>

    			<Button
            buttonType={ButtonTypes.Secondary}
            className="button"
            
          >
            Log off
          </Button>

	</Header>
);
