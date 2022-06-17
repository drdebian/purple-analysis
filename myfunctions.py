from typing import Dict, Any
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm


def load_ev_data(raw_ev_data: pd.DataFrame, phases: Dict, freq: Any) -> pd.DataFrame:

    # config_model['vehicles']
    my_vehicles = sorted(
        list(set(raw_ev_data.index.get_level_values("vehicle"))))
    phase1 = phases["phase1"]
    phase2 = phases["phase2"]
    phase3 = phases["phase3"]
    phase4 = phases["phase4"]
    end = phases["end"]

    appended_data = []
    for v in my_vehicles:
        my_vehicle = raw_ev_data.copy().loc[pd.IndexSlice[v, :], :]

        # # my_vehicle['status'] = 'ride'

        my_vehicle.status = my_vehicle.status.fillna('idle')
        my_vehicle.reset_index(inplace=True, drop=False)
        my_vehicle.timestamp = pd.to_datetime(my_vehicle.timestamp)
        my_vehicle.set_index('timestamp', inplace=True)
        my_vehicle.sort_index()
        my_vehicle = my_vehicle.resample(freq).agg(
            {'vehicle': 'max',
             'status': 'max',
             'state': 'max',
             'stateOfCharge': 'mean',
             'chgSOC': 'mean',
             'activePower-W': 'mean',
             'state': 'max',
             'loadable': 'max',
             'charging': 'max',
             'driving': 'max'
             }
        ).pad()

        # detect end of loadable period and generate loadend flag
        my_vehicle['loadend'] = False
        my_vehicle.loc[(my_vehicle.loadable >
                        my_vehicle.loadable.shift(-1)), 'loadend'] = True

        # detect end of driving period and generate driveend flag
        my_vehicle['driveend'] = False
        my_vehicle.loc[(my_vehicle.driving >
                        my_vehicle.driving.shift(-1)), 'driveend'] = True

        # detect beginning of loadable period and generate loadbeg flag
        my_vehicle['loadbeg'] = False
        my_vehicle.loc[(my_vehicle.loadable <
                        my_vehicle.loadable.shift(-1)), 'loadbeg'] = True

        # detect beginning of driving period and generate drivebeg flag
        my_vehicle['drivebeg'] = False
        my_vehicle.loc[(my_vehicle.driving <
                        my_vehicle.driving.shift(-1)), 'drivebeg'] = True

        # add date features for analysis
        my_vehicle['datetime'] = my_vehicle.index
        my_vehicle['date'] = my_vehicle['datetime'].dt.date
        my_vehicle['time'] = my_vehicle['datetime'].dt.time
        my_vehicle['hour'] = my_vehicle['datetime'].dt.hour
        my_vehicle['dayofweek'] = my_vehicle['datetime'].dt.dayofweek
        my_vehicle.drop("datetime", axis=1, inplace=True)

        # add field test phases
        my_vehicle["phase"] = 0
        my_vehicle.loc[phase1:phase2, "phase"] = 1
        my_vehicle.loc[phase2:phase3, "phase"] = 2
        my_vehicle.loc[phase3:phase4, "phase"] = 3
        my_vehicle.loc[phase4:end, "phase"] = 4

        appended_data.append(my_vehicle)
    my_ev = pd.concat(appended_data, axis=0)
    my_ev.reset_index(inplace=True)
    my_ev.set_index(['vehicle', 'timestamp'], inplace=True, drop=True)

    return my_ev


def filter_ev_data_first_departure_per_day(ev_data: pd.DataFrame) -> pd.DataFrame:

    # filter ev_data for "begin driving" flag
    #df3 = ev_data.loc[(ev_data.stateOfCharge > 0) & (ev_data.drivebeg == True)]
    df3 = ev_data.loc[(ev_data.drivebeg == True)]

    # find earliest time of departure per day
    df3mintime = pd.DataFrame(df3.groupby(['vehicle', 'date'])[
                              "time"].min()).reset_index()
    df3mintime["timestamp"] = pd.to_datetime(
        df3mintime["date"].astype(str) + ' ' + df3mintime["time"].astype(str))
    df3mintime.drop(["date", "time"], axis=1, inplace=True)

    # find associated data from input dataframe
    my_ev = df3.loc[pd.MultiIndex.from_frame(df3mintime), :]

    return my_ev


def bar3d_plot(mydata: pd.DataFrame, xlabel="", ylabel="", zlabel="", title="", color="red"):

    if color == "red":
        cmap = cm.Reds
    elif color == "rainbow":
        cmap = cm.rainbow
    else:
        cmap = cm.Greens

    data = mydata.to_numpy()
    column_names = list(mydata.columns)
    row_names = list(mydata.index.values)

    fig = plt.figure(figsize=(8, 8))
    ax = fig.add_subplot(111, projection='3d')

    lx = len(data[0])
    ly = len(data[:, 0])
    width = .22
    xpos = np.arange(0, lx, 1)
    ypos = np.arange(0, ly, 1)
    xpos, ypos = np.meshgrid(xpos-width*.35, ypos-width)

    xpos = xpos.flatten()
    ypos = ypos.flatten()
    zpos = np.zeros(lx*ly)

    dx = width * np.ones_like(zpos)
    dy = dx.copy()
    dz = data.flatten()

    values = np.linspace(0.2, 1., xpos.ravel().shape[0])
    #colors = cm.rainbow(values)
    colors = cmap(values)
    ax.bar3d(xpos, ypos, zpos, dx, dy, dz, color=colors, alpha=.5)

    ticksx = np.arange(0., lx, 1)
    plt.xticks(ticksx, column_names, fontsize=8)

    ticksy = np.arange(0., ly, 1)
    plt.yticks(ticksy, row_names, fontsize=8)

    ax.set_xlabel(xlabel, fontsize=9)
    ax.set_ylabel(ylabel, fontsize=9)
    ax.set_zlabel(zlabel, fontsize=9)
    ax.set_title(title)

    # fig.tight_layout()

    return(fig)


# define PAPR function for evaluation
def papr(x):
    return np.max(x)/np.mean(x)