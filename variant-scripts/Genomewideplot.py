import pandas as pd
import plotly.express as px

dataFrame = pd.read_excel("E:/602uniquesnps/final611describe.xlsx")

# Impact Size
sz = {
    'HIGH': 4,
    'LOW': 2,
    'MODERATE': 3,
    'MODIFIER': 1
}
dataFrame['Impact'] = dataFrame['Impact'].map(sz)

# Shape for Types of variants
sp = {
    'snp': 'circle',
    'mnp': 'square',
    'del': 'diamond',
    'ins': 'triangle-up',
    'complex': 'cross'
}

fig = px.scatter(dataFrame,
                 x='Position',
                 y='Chromosome',
                 color='Region of Variation',
                 size='Impact',
                 size_max=10,
                 symbol='Variant Type',
                 symbol_map=sp,
                 color_discrete_sequence=px.colors.qualitative.Dark24,
                 labels={'Position': 'Genomic Position', 'Chromosome': 'Chromosome'},
                 title='Genome-wide Plot of Variant Positions'
                 )

fig.update_traces(marker=dict(line=dict(width=1, color='DarkSlateGrey')))
fig.update_layout(legend=dict(title='Region of Variation'))
fig.show()
