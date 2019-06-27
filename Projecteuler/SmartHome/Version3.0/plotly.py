import plotly.plotly as py
import plotly.graph_objs as go
import time
import datetime

# Create random data with numpy
import numpy as np

N = 500
plot_x = np.linspace(0, 1, N)
plot_y = np.random.randn(N)

# Create a trace
trace = go.Scatter(
    x = plot_x,
    y = plot_y
)

data = [trace]

py.plot(data, filename='2018-09-23_humidity', auto_open=False)