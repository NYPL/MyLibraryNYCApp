import React, { useState, useEffect, useRef } from "react";
import {
  Image,
  Box,
  useColorModeValue,
} from "@nypl/design-system-react-components";

export default function ShowBookImage(props) {
  const [srcToUse, setSrcToUse] = useState(props.src);
  const imgLoadedOnInitSrc = useRef(false);
  const [fallBackImageStatus, setFallBackImageStatus] = useState(false);
  const [bookImageHeight, setBookImageHeight] = useState("");
  const [bookImageWidth, setbookImageWidth] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const bookTitleColor = useColorModeValue(
    "var(--nypl-colors-ui-link-primary)",
    "var(--nypl-colors-dark-ui-link-primary)"
  );

  useEffect(() => {
    const timer = setTimeout(() => {
      if (!imgLoadedOnInitSrc.current) setFallBackImageStatus(true);
      setIsLoading(true);
    }, 6000);

    return () => clearTimeout(timer);
  }, []);

  const bookImages = () => {
    if (
      (bookImageHeight === 1 && bookImageWidth === 1) ||
      fallBackImageStatus === true
    ) {
      return (
        <Box
          paddingLeft="s"
          padding="s"
          width="189px"
          height="189px"
          color={bookTitleColor}
        >
          {props.book.title}
        </Box>
      );
    } else if (bookImageHeight === 189 && bookImageWidth === 189) {
      return (
        <Image
          title={props.book.title}
          src={srcToUse}
          aspectRatio="square"
          size="default"
          alt={props.book.title}
          className="bookImageTop"
        />
      );
    } else {
      return (
        <img
          title={props.book.title}
          onLoad={bookImageDimensions}
          src={srcToUse}
          style={{ display: isLoading ? "block" : "none" }}
        />
      );
    }
  };

  const bookImageDimensions = ({ target: img }) => {
    if (img.offsetHeight === 1 || img.offsetWidth === 1) {
      setBookImageHeight(img.offsetHeight);
      setbookImageWidth(img.offsetWidth);
    } else {
      setBookImageHeight(189);
      setbookImageWidth(189);
    }
    return (imgLoadedOnInitSrc.current = true);
  };

  return <> {bookImages()} </>;
}
