#  CNN Coding Exercise Using Unsplash

## Requirements
The application must return a list of specific images using a search capability.

The application must display search results in a manageable user experience.

The search functionality must support the capability to retrieve all the images for a specific search criteria.  (Ex. “Star Wars” search should show those types of images)

The application must implement a “Favorites” feature allowing the user to tag images.

The application must implement a search suggestion feature that provides the user a list of frequently searched for terms.  This feature should integrate with the search capability from above.

The application must support the capability of displaying recents searches.  This feature should integrate with the search capability from above.

The application supports the capability to view image detail information page

### Notes

First things first, thank you for the opportunity for taking this coding exercise.  Here is how I addressed the requirements.

I used the Unsplash API search endpoint to return a list of images based off of a query string.  I display the matching images in a UISearchController.  Since I pass in the query string, it should return matching data.  I limited the response to 24 results for one page (if 24 results exist).

I persist a favorites feature through UserDefaults.  If a user decides to favorite photos after first launch of the app, I go ahead and store the photo identifiers in UserDefaults.  If a user has already favorited photos, I make sure to filter duplicate ids before adding the photo to UserDefaults.  Favorited photos should update based on whether the user taps the favorited(heart) button in the search detail view.

I also persist recent searches in UserDefaults.  If a user has never searched the app before, I show an empty view that prompts the user to search.  If a user finishes editing their search, that search term will appear in the recent searches.  If a user hits cancel or the clear button, that search term will not be added to recent searches.  If there are any recent search terms in UserDefaults, the list of recent searches will show, otherwise that empty view will show again.  

I also only allow for 5 search terms at a time.  If there is a duplicate, I delete the duplicate and move that search term to index 0.  If the max amount is exceeded, I delete the last index.

Both the regular search and the favorited pictures list have detail views that show who took the picture and it's associated description.  If there is no description, I fallback on an alternative description provide by the API.

I implemented an autocomplete feature that suggests a search term based off of the tags associated with their favorited photos.  It won't autocomplete if a user has no favorited photos or if a user gets rid of all of their favorited photos.

#### Further development

This project was a lot of fun.  If I had more time to devote to it this past week I would have done the following:

My number one goal would be to further flesh out the suggested searches function.  I connected the autocomplete feature to the favorited picture's tags, but I intended to create a drop down with other tags related to the search text.  

I would have added a loading indicator on the launch screen and during anytime the app is fetching data.

I would have added pagination logic to handle responses with larger results.

I would have fleshed out the error handling so the user could have a more detailed reason on why a request to the API isn't working.

I would flesh out the details of both detailed views, and maybe make them a bit different.  For the regular search view, I would just provide a link to the photographers account and their social handles.  If a user favorited their photo, I would show their bio, some hotlinks to their photo, and other collections if they have any.  I would have also done a share feature in the favorited photo detail view.

I would add a featured tab that immediately loaded the newest photos based off of matching tags from their favorites list.  If there are no tags to work with, I would just make a general request to their api to feature any of their newest photos

I would also add a more menu that includes FAQs, a push notification toggle, etc. (generally best practices that are included in most more menus)

Instead of UserDefaults, I would have played around with implementing a CoreData stack.  I would definitely save the user as an entity, and also create an entity for favorited photos.  I think CoreData may work in the long run if I had the chance to implement the user authorization endpoint and a user login flow, but as the app stands currently, I think that the data returned in the response and my use of it was simple enough to store in user defaults.

I could go on forever, especially since none of the above include associated Unit Testing.

Thank you again for the opportunity!
