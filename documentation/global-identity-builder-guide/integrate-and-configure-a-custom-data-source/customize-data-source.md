# Customize Data Source

The Azure application APPLICATION ID and PASSWORD KEY are required to configure the Azure AD data source.

24. On the Main Control Panel > Settings tab > Server Backend section, go to Custom Data Sources.

25. On the right, select **mgraph** and select **Clone**.

26. Enter a data source name and select **Clone**. Select **OK** to exit the confirmation. In this example, the data source is named `azureadglobalrlitenant`.

![Azure AD Custom Data Source](./media/image102.png)

Azure AD Custom Data Source

27. Choose the new data source (e.g. `azureadglobalrlitenant`) and select **Edit**.

![Editing Custom Data Source](./media/image103.png)

Editing Custom Data Source

28. Choose the `username` property and select **Edit**.

29. Enter the value of the Azure AD Application ID and select **OK**.

30. Choose the `password` property and select **Edit**.

31. Enter the password key associated with your Azure AD application and select **OK**.

32. Choose the `oauthurl` property and select **Edit**. Enter the URL for your Azure AD tenant (e.g. `https://login.microsoftonline.com/{YOUR_TENANT_NAME}/oauth2/v2.0/token`) and select **OK**.

33. Choose the `active` property and select **Edit**.

34. Set the value to `true` and select **OK**.

35. Select **Save**.
