import requests
from bs4 import BeautifulSoup
import csv

# 8.1 - Create CSV file named books_data.csv
with open("books_data.csv", "w", newline="", encoding="utf-8") as file:
    
    # 8.2 - Define columns: Title, Price, Availability
    writer = csv.writer(file)
    writer.writerow(["Title", "Price", "Availability"])

    # 8.3 - Loop through at least 2 pages
    for page_num in range(1, 3):  # pages 1 and 2
        url = f"https://books.toscrape.com/catalogue/page-{page_num}.html"
        response = requests.get(url)
        
        print(f"Scraping Page {page_num} — Status Code: {response.status_code}")
        
        # Parse HTML
        soup = BeautifulSoup(response.content, "html.parser")
        books = soup.find_all("article", class_="product_pod")
        
        # Extract and write each book to CSV
        for book in books:
            title        = book.find("h3").find("a")["title"]
            price        = book.find("p", class_="price_color").text.strip()
            availability = book.find("p", class_="instock availability").text.strip()
            
            # Write row to CSV
            writer.writerow([title, price, availability])
            
            # Display in terminal
            print(f"  Title:        {title}")
            print(f"  Price:        {price}")
            print(f"  Availability: {availability}")
            print("  " + "-" * 48)

print("\n✅ Data successfully saved to books_data.csv")