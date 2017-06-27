module FeatureSpecHelpers

  def table_data_by_row_and_column(row, column)
    first("table tbody tr:nth-of-type(#{row}) td:nth-of-type(#{column})").text
  end
end
