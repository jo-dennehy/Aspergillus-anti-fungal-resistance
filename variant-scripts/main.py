import pandas as pd
import plotly.express as px

variantsDetails = pd.read_excel("E:/distance plot/final611describe.xlsx")

# Data cleaning
variantsDetails = variantsDetails.dropna(subset=["Gene Start", "Position", "Gene End"])

# Columns data conversion to numbers
cols = ["Gene Start", "Gene End", "Position"]
variantsDetails[cols] = variantsDetails[cols].apply(pd.to_numeric)


# For positive strand distance calculation
def fivedistance(data):
    if data['Strand'] == '+':
        return data['Position'] - data['Gene Start']
    else:
        return data['Gene End'] - data['Position']


def distanceFromThreePrimeEnd(data):
    if data['Strand'] == '+':
        return data['Gene End'] - data['Position']
    else:
        return data['Position'] - data['Gene Start']


variantsDetails['Variant_3prime_Distance'] = variantsDetails.apply(distanceFromThreePrimeEnd, axis=1)
variantsDetails['Variant_5prime_Distance'] = variantsDetails.apply(fivedistance, axis=1)

# For negative strand
index_negate = variantsDetails['Strand'] == '-'


def distanceFromFiveOfNegativeStrand(data):
    if pd.notnull(data['Gene Start']) and pd.notnull(data['Position']):
        return data['Gene Start'] - data['Position']
    else:
        return pd.NA


def distanceFromThreeOfNegativeStrand(data):
    if pd.notnull(data['Gene End']) and pd.notnull(data['Position']):
        return data['Position'] - data['Gene End']
    else:
        return pd.NA


variantsDetails.loc[index_negate, 'Variant_3prime_Distance'] = variantsDetails.loc[index_negate].apply(
    distanceFromThreeOfNegativeStrand, axis=1)
variantsDetails.loc[index_negate, 'Variant_5prime_Distance'] = variantsDetails.loc[index_negate].apply(
    distanceFromFiveOfNegativeStrand, axis=1)

# Graph
fig = px.scatter(variantsDetails, x='Variant_3prime_Distance', y='Variant_5prime_Distance', color='Chromosome',
                 title='Af_6_1_1 Variants Distance to Next Gene',
                 labels={'Variant_3prime_Distance': "Variant 3' Distance to Next Gene",
                         'Variant_5prime_Distance': "Variant 5' Distance from Next Gene", 'Chromosome': 'Chromosome'})
fig.show()
