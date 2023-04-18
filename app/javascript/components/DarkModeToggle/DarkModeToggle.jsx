import React from "react";
import {
  Box,
  Toggle,
  useColorMode,
  useColorModeValue,
  useNYPLBreakpoints,
} from "@nypl/design-system-react-components";

/**
 * Toggle between the light and dark mode DS component variants.
 */
export default function DarkModeToggle() {
  const { colorMode, toggleColorMode } = useColorMode();
  const { isLargerThanMobile } = useNYPLBreakpoints();

  const handleChange = () => {
    const newColorMode = colorMode === "light" ? "dark" : "light";
    console.log(
      `Color mode is switching from ${colorMode} to ${newColorMode}.`
    );
    toggleColorMode();
  };

  return (
    <Box
      bgColor={useColorModeValue("ui.bg.default", "dark.ui.bg.default")}
      borderRadius="32px"
      boxShadow={useColorModeValue(
        "0px 0px 8px 0px rgba(0,0,0,0.25)",
        "0px 0px 8px 0px rgba(255,255,255,0.25)"
      )}
      paddingEnd="s"
      paddingStart="12px"
      py="xs"
    >
      <Toggle
        id="darkModeToggle"
        isChecked={colorMode === "dark"}
        labelText="Dark Mode"
        onChange={handleChange}
        size={isLargerThanMobile ? "small" : "default"}
        sx={{
          label: {
            width: { base: "auto", md: "fit-content" },
          },
        }}
      />
    </Box>
  );
};