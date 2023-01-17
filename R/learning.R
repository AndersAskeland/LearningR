# Here's an example of a conflict.
library(tidyverse)
library(NHANES)

# Making code more readable section (Styler) ------------------------------------------------------------

# Object names
DayOne
T <- FALSE
c <- 9

# Spacing
x[, 1]
x[, 1]
mean(x, na.rm = TRUE)
mean(x, na.rm = TRUE)
height <- feet * 12 + inches
df$ z
x <- 1:10


# Looking at data ---------------------------------------------------------

glimpse(NHANES)
colnames(NHANES)

select(NHANES, Age, Weight, BMI)

select(NHANES, -HeadCirc)

select(NHANES, starts_with("BP"))
select(NHANES, ends_with("Day"))
select(NHANES, contains("Age"))

nhanes_small <- select(
  NHANES,
  Age,
  Gender,
  BMI,
  Diabetes,
  PhysActive,
  BPSysAve,
  BPDiaAve,
  Education
)
nhanes_small


# Fixing variable names ---------------------------------------------------

nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)

nhanes_small <- rename(
  nhanes_small,
  sex = gender
)


# Piping ------------------------------------------------------------------

colnames(nhanes_small)

nhanes_small %>%
  colnames()
nhanes_small %>%
  select(phys_active) %>%
  rename(
    physically_active = phys_active
  )


# Filtering rows ----------------------------------------------------------

nhanes_small %>%
  filter(phys_active != "No")

nhanes_small %>%
  filter(
    bmi >= 25,
    phys_active == "No"
  )

nhanes_small %>%
  filter(bmi >= 25 |
    phys_active == "No")


# Arranging rows ----------------------------------------------------------

nhanes_small %>%
  arrange(desc(age), bmi, education)


# Mutating columns --------------------------------------------------------

nhanes_update <- nhanes_small %>%
  mutate(
    age_month = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_month * 4,
    old = if_else(
      age >= 30,
      "old",
      "young"
    )
  )


# Summarizing -------------------------------------------------------------

nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(
    diabetes,
    phys_active
  ) %>%
  summarize(
    max_bmi = max(bmi,
      na.rm = TRUE
    ),
    min_bmi = min(bmi,
      na.rm = TRUE
    )
  ) %>%
  ungroup()

write_csv(
  nhanes_small,
  here::here("data/nhanes_small.csv")
)
