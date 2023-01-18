import React, { useState, useEffect, useRef } from "react";
import mlnImage from "../images/mln.svg";
import { Image, Box, SkeletonLoader, Text,} from "@nypl/design-system-react-components";

export default function ImageWithFallback(props) {
  const [srcToUse, setSrcToUse] = useState(props.src)
  const imgLoadedOnInitSrc = useRef(false)
  const [fallBackImageStatus, setFallBackImageStatus] = useState(false)
  const [bookImageHeight, setBookImageHeight] = useState("");
  const [bookImageWidth, setbookImageWidth] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const [timeOutImage, setTimeOutImage] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
        if (!imgLoadedOnInitSrc.current) setFallBackImageStatus(true)
          setIsLoading(true)
    }, 10000)

    return () => clearTimeout(timer)
  }, [])

  const bookImages = () => {
    if (bookImageHeight === 1 && bookImageWidth === 1) {
      return <Image
        title={props.book.title}
        src={mlnImage}
        aspectRatio="square"
        size="default"
        alt={props.book.title}
        className="bookImageTop"
      />
    } else if (bookImageHeight === 189 && bookImageWidth === 189) {
      return <Image
        title={props.book.title}
        src={srcToUse}
        aspectRatio="square"
        size="default"
        alt={props.book.title}
        className="bookImageTop"
      />
    }
    else if (fallBackImageStatus === true) {
      return <Box bg="var(--nypl-colors-ui-gray-x-light-cool)" paddingLeft="s" padding="s" width="189px" height="189px">{props.book.title}</Box>
    }
    else {
      return <img title={props.book.title} onLoad={bookImageDimensions} src={srcToUse} style={{ display: isLoading ? "block" : "none" }} />
    }
  }

  const bookImageDimensions = ({ target: img }) => {
    setTimeOutImage(true)
    if (img.offsetHeight === 1 || img.offsetWidth === 1) {
      setBookImageHeight(img.offsetHeight);
      setbookImageWidth(img.offsetWidth);
    } else {
      setBookImageHeight(189);
      setbookImageWidth(189);
    }
    return imgLoadedOnInitSrc.current = true
  };

  return ( <> {bookImages()} </>)
}