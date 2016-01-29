# FISCardStreams


Flatiron team notes:


KNOWN ISSUES:

All API Clients:

Currently do not generate and pass along errors. Some block methods return a "success" BOOL but this is not standardized across the application. At least one block method has two completion blocks which should be renamed Success & Failure for good practice.

FISGithubAPIClient:

Should be modified to pull private commit information instead of just public commits through the network activity


FISCardsTableViewController (this is the logged-in user's feed)

Currently handles not having a stack exchange token submitted, but should also allow for the absence of github token and blog URL

TableView should also reload after opening up no github token or blog GET request is possible--right now the update BOOLs do not handle this

Currently using the WebViewTableViewCell for displaying stack exchange cards. The StackExchangeTableViewCell's text view was not loading correctly.


FISCardViewController (this is the group view controller)

TableView contained inside the CollectionViewCell sometimes breaks when scrolled down.



FUTURE PLANS:

Add password field for user authentication in login flow, possibly using the 'streamDescription' property to contain this information. However, since this field is publicly visible, passwords would need to be converted to and transmitted as hashes.

The application should detect a previous log-in session (that was not logged-out) and skip the login page going directly to the initial VC in the "main" storyboard.

The homepage should be a summary or analytics page and not the feed/timeline itself.



<p data-visibility='hidden'>View <a href='https://learn.co/lessons/FISCardStreams' title='FISCardStreams'>FISCardStreams</a> on Learn.co and start learning to code for free.</p>
