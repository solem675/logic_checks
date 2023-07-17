# Data cleaning scripts. Ukraine CO RAM
Data cleaning scripts, Ukraine CO RAM

## Logic cross-checks

Are meant for identifying logic flaws in submissions (categorical variables) and returning them for case-to-case revision and/or clarification with field teams.

As an input file, the logic frame for logic checks is needed. It has to indicate what combinations of values in selected variables constitute the survey logic fallacy.

- "target_var" - variable to be checked
- "target_val" - value in target_var that has to be checked
- "cross_var" - variable which target_var should be crosschecked with
- "cross_val" - value in cross_var, target_val should not cooccure with

### Categorical cross_checks

get_logic_errors_categorical()

Logic cross-checks between two categorical variables.

Arguments:

- data dataframe to be checked
- logic_frame dataframe with logic frame (with aforementioned variables)
- id_col character value, name of column, containing unique ids
- enum_col="complementary_col" character, name of coulumn, containing enumerator's id (optional)
- date_col="complementary_col", character, name of column, containing date (optional)
- enum_com_col="complementary_col", character, name of column, containing enumerator's comment (optional)
- index_col="complementary_col" character, name of column with index (for datasets, containing loops within submissions)

Value:

Logic errors frame.

Example:

``` {r}

```
