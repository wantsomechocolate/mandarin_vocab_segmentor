import csv


with open('blogs_wordfreq.release_UTF-8.txt', encoding='utf8', mode='r') as infile:
	reader = csv.reader(infile, delimiter='\t')
	blog_dict = {rows[0]:rows[1] for rows in reader}

print('Read blogs_wordfreq')

with open('literature_wordfreq.release_UTF-8.txt', encoding='utf8', mode='r') as infile:
	reader = csv.reader(infile, delimiter='\t')
	lit_dict = {rows[0]:rows[1] for rows in reader}

print('Read literature_wordfreq')

for word in lit_dict:
	if word in blog_dict:
		blog_dict[word] = str(int(blog_dict[word]) + int(lit_dict[word]))
	else:
		blog_dict[word] = lit_dict[word]

print('Combined literature into blogs')

with open('news_wordfreq.release_UTF-8.txt', encoding='utf8', mode='r') as infile:
	reader = csv.reader(infile, delimiter='\t')
	news_dict = {rows[0]:rows[1] for rows in reader}

print('Read news_wordfreq')

for word in news_dict:
	if word in blog_dict:
		blog_dict[word] = str(int(blog_dict[word]) + int(news_dict[word]))
	else:
		blog_dict[word] = news_dict[word]

print('Combined news into blogs')

with open('technology_wordfreq.release_UTF-8.txt', encoding='utf8', mode='r') as infile:
	reader = csv.reader(infile, delimiter='\t')
	tech_dict = {rows[0]:rows[1] for rows in reader}

print('Read technology_wordfreq')

for word in tech_dict:
	if word in blog_dict:
		blog_dict[word] = str(int(blog_dict[word]) + int(tech_dict[word]))
	else:
		blog_dict[word] = tech_dict[word]

print('Combined tech into blogs')

with open('weibo_wordfreq.release_UTF-8.txt', encoding='utf8', mode='r') as infile:
	reader = csv.reader(infile, delimiter='\t')
	weibo_dict = {rows[0]:rows[1] for rows in reader}

print('Read weibo_wordfreq')

for word in weibo_dict:
	if word in blog_dict:
		blog_dict[word] = str(int(blog_dict[word]) + int(weibo_dict[word]))
	else:
		blog_dict[word] = weibo_dict[word]

print('Combined weibo into blogs')


outlist = ''
for word in blog_dict:
	outlist += str(word) + '\t' + blog_dict[word] + '\n'


outfile = open("blog_lit_news_tech_weibo_freq.release.txt", "w", encoding="utf8")
outfile.write(outlist)
outfile.close()

print('Wrote the five')