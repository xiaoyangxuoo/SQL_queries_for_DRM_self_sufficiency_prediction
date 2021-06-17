SELECT DISTINCT
       description as "Description",
       ProviderName as "Mentor Name",
       provider.CreatedDate as "Join Date"
FROM Provider
    INNER JOIN ProviderTypeCategory
        ON provider.EntityID = ProviderTypeCategory.EntityID
    INNER JOIN ProviderTypeCategoryType
        ON ProviderTypeCategory.ProviderTypeCategoryTypeID = ProviderTypeCategoryType.ProviderTypeCategoryTypeID --- 
		------------Explanation of the two tables available
		-- Provider： name of the provider (potential providers), with their entityID presented
		-- ProviderTypeCategory: Table which relates the type of service to each person/provider (kind of redundant?), with their providerTYpeCategoryTypeID as key
		-- ProviderTypeCategoryType: Table that relates the TypeCategoryTypeID to the description of the service provided

WHERE ProviderTypeCategory.ProviderTypeCategoryTypeID = 1000000023 ---- this 1000000009, 1000000011, 1000000012, 1000000013, 1000000014,
                                                           --1000000015, 1000000016  is restricting to the crossing  NLP/STAR 
      AND provider.X_ProviderStatus = 25 --25 = Ready for Matching, awaiting for mentees
      AND ProviderName NOT LIKE '%test%' --- not including the testing mentor records
      AND NOT EXISTS
        (
        SELECT dbo.CaseManagerAssignment.UserID
        FROM dbo.CaseManagerAssignment
        WHERE GETDATE() BETWEEN BeginDate AND EndDate
        AND DeletedDate > GETDATE()
        AND dbo.Provider.EntityID = dbo.CaseManagerAssignment.UserID
        ) --- This block of code is excluding the service providers that have already been assigned
GROUP BY ProviderName,
         provider.CreatedDate,
         Description
ORDER BY description,
         ProviderName ASC;