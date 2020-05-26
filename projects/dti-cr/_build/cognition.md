---
interact_link: content/cognition.ipynb
kernel_name: python3
has_widgets: false
title: 'Cognition'
prev_page:
  url: /age-group.html
  title: 'Age-group'
next_page:
  url: /rhythm-amplitude.html
  title: 'Rhythm-amplitude'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
# GLM



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import sys

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'
data_dir = '/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/data/'

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
d = []
d = pd.read_csv(data_dir + 'dataset_2020-04-09.csv')
d = d.sort_values('record_id', ascending = True)
d['sex'] = np.where(d['sex'] == 'Female', 0, 1)
d[0:5]

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>record_id</th>
      <th>actamp</th>
      <th>actbeta</th>
      <th>actphi</th>
      <th>actmin</th>
      <th>actmesor</th>
      <th>actupmesor</th>
      <th>actdownmesor</th>
      <th>actalph</th>
      <th>actwidthratio</th>
      <th>...</th>
      <th>cowat_zscore</th>
      <th>cowat_perseveration</th>
      <th>cowat_errors</th>
      <th>time_trails_a</th>
      <th>error_trails_a</th>
      <th>trails_a_z_score</th>
      <th>time_trails_b</th>
      <th>error_trails_b</th>
      <th>trails_b_z_score</th>
      <th>neuropsych_scoring_complete</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>30003</td>
      <td>1.389856</td>
      <td>21.815009</td>
      <td>14.373034</td>
      <td>0.541285</td>
      <td>1.236213</td>
      <td>6.117306</td>
      <td>22.628763</td>
      <td>-0.556815</td>
      <td>0.687977</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35.0</td>
      <td>0.0</td>
      <td>-1.756914</td>
      <td>97.0</td>
      <td>0.0</td>
      <td>-3.784870</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>1</td>
      <td>30004</td>
      <td>1.630892</td>
      <td>4.438790</td>
      <td>15.128163</td>
      <td>0.000000</td>
      <td>0.815446</td>
      <td>6.927406</td>
      <td>23.328920</td>
      <td>-0.544804</td>
      <td>0.683396</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>25.0</td>
      <td>0.0</td>
      <td>-0.068886</td>
      <td>59.0</td>
      <td>0.0</td>
      <td>-0.673139</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>2</td>
      <td>30008</td>
      <td>1.610484</td>
      <td>7.306045</td>
      <td>15.569911</td>
      <td>0.139627</td>
      <td>0.944868</td>
      <td>7.708287</td>
      <td>23.431534</td>
      <td>-0.468304</td>
      <td>0.655135</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>27.0</td>
      <td>0.0</td>
      <td>-0.592431</td>
      <td>60.0</td>
      <td>1.0</td>
      <td>-0.869188</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>3</td>
      <td>30009</td>
      <td>1.951245</td>
      <td>7.026165</td>
      <td>14.377649</td>
      <td>0.081641</td>
      <td>1.057264</td>
      <td>6.388996</td>
      <td>22.366302</td>
      <td>-0.497424</td>
      <td>0.665721</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35.0</td>
      <td>0.0</td>
      <td>-1.216992</td>
      <td>61.0</td>
      <td>0.0</td>
      <td>-0.834951</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>4</td>
      <td>30012</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35.0</td>
      <td>1.0</td>
      <td>-1.216992</td>
      <td>54.0</td>
      <td>0.0</td>
      <td>-0.268608</td>
      <td>2.0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 742 columns</p>
</div>
</div>


</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
oa_files = []
oa_files = pd.DataFrame(os.listdir(scan_dir + '/tbss_oa/origdata'), columns = ['files'])
oa_files['record_id'] = oa_files['files'].str.split('-', expand = True)[1].str.split('_', expand = True)[0].astype(int)
oa_files = oa_files.drop('files', axis=1)
oa_files = oa_files.set_index('record_id')

oa_df = []
oa_df = d[d['Group'] == 'Older Adults']
oa_df = oa_df.set_index('record_id')

oa_dsn = []
oa_dsn = oa_files.join(oa_df, sort=True).dropna(subset = ['files'])

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
oa_dsn.shape

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
(57, 741)
```


</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
ya_files = []
ya_files = pd.DataFrame(os.listdir(scan_dir + '/tbss_ya/origdata'), columns = ['files'])
ya_files['record_id'] = ya_files['files'].str.split('-', expand = True)[1].str.split('_', expand = True)[0].astype(int)
ya_files = ya_files.drop('files', axis=1)
ya_files = ya_files.set_index('record_id')

ya_df = []
ya_df = d[d['Group'] == 'Young Adults']
ya_df = ya_df.set_index('record_id')

ya_dsn = []
ya_dsn = ya_files.join(ya_df, sort=True).dropna(subset = ['files'])

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
ya_dsn.shape

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
(46, 741)
```


</div>
</div>
</div>



## Trails B Performance and WM



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
d[['record_id', 'Group', 'trails_b_z_score']]

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>record_id</th>
      <th>Group</th>
      <th>trails_b_z_score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>30003</td>
      <td>Young Adults</td>
      <td>-3.784870</td>
    </tr>
    <tr>
      <td>1</td>
      <td>30004</td>
      <td>Young Adults</td>
      <td>-0.673139</td>
    </tr>
    <tr>
      <td>2</td>
      <td>30008</td>
      <td>Young Adults</td>
      <td>-0.869188</td>
    </tr>
    <tr>
      <td>3</td>
      <td>30009</td>
      <td>Young Adults</td>
      <td>-0.834951</td>
    </tr>
    <tr>
      <td>4</td>
      <td>30012</td>
      <td>Young Adults</td>
      <td>-0.268608</td>
    </tr>
    <tr>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <td>125</td>
      <td>40861</td>
      <td>Older Adults</td>
      <td>-2.457573</td>
    </tr>
    <tr>
      <td>126</td>
      <td>40876</td>
      <td>Older Adults</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>127</td>
      <td>40878</td>
      <td>Older Adults</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>128</td>
      <td>40891</td>
      <td>Older Adults</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>129</td>
      <td>40930</td>
      <td>Older Adults</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>130 rows × 3 columns</p>
</div>
</div>


</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
imp = []
imp = oa_dsn[['record_id', 'Group', 'trails_b_z_score']]
imp['trails_b_z_score'] = imp['trails_b_z_score'].fillna(oa_dsn['trails_b_z_score'].mean())
imp['trails_b_z_score'] = imp['trails_b_z_score'] - imp['trails_b_z_score'].mean()
imp

np.savetxt(scan_dir + 'tbss_oa/stats/dsn_tmtbz.txt', imp[['trails_b_z_score']].values, fmt = '%f')


```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
imp = []
imp = ya_dsn[['record_id', 'Group', 'trails_b_z_score']]
imp['trails_b_z_score'] = imp['trails_b_z_score'].fillna(ya_dsn['trails_b_z_score'].mean())
imp['trails_b_z_score'] = imp['trails_b_z_score'] - imp['trails_b_z_score'].mean()
imp

np.savetxt(scan_dir + 'tbss_ya/stats/dsn_tmtbz.txt', imp[['trails_b_z_score']].values, fmt = '%f')


```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
Text2Vest dsn_tmtbz.txt dsn_tmtbz.mat

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
Text2Vest dsn_tmtbz.txt dsn_tmtbz.mat

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
ls *.con

printf "1\n-1" > 1var.txt
Text2Vest 1var.txt 1var.con

randomise -i all_FA_skeletonised -o tbss_oa_dsn_tmtbz -d dsn_tmtbz.mat \
-t 1var.con -n 500 --T2 -D

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
3var.con
randomise options: -i all_FA_skeletonised -o tbss_oa_dsn_tmtbz -d dsn_tmtbz.mat -t 1var.con -n 500 --T2 -D 
Loading Data: 
Data loaded
1.26647e+75 permutations required for exhaustive test of t-test 1
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_oa_dsn_tmtbz_tfce_tstat1 is: 298253
1.26647e+75 permutations required for exhaustive test of t-test 2
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_oa_dsn_tmtbz_tfce_tstat2 is: 276657
Finished, exiting.
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats

ls *tmtbz*

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
dsn_tmtbz.mat
dsn_tmtbz.txt
tbss_oa_dsn_tmtbz_tfce_corrp_tstat1.nii.gz
tbss_oa_dsn_tmtbz_tfce_corrp_tstat2.nii.gz
tbss_oa_dsn_tmtbz_tstat1.nii.gz
tbss_oa_dsn_tmtbz_tstat2.nii.gz
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_oa/stats/tbss_oa_dsn_tmtbz_tfce_corrp_tstat1.nii.gz', threshold = 0.90, title = 'TMT-B')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x120cdf910>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/cognition_14_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_oa/stats/tbss_oa_dsn_tmtbz_tfce_corrp_tstat2.nii.gz', threshold = 0.90, title = 'TMT-B')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x1205cdc10>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/cognition_15_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
ls *.con

printf "1\n-1" > 1var.txt
Text2Vest 1var.txt 1var.con

randomise -i all_FA_skeletonised -o tbss_ya_dsn_tmtbz -d dsn_tmtbz.mat \
-t 1var.con -n 500 --T2 -D

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
3var.con
4var.con
randomise options: -i all_FA_skeletonised -o tbss_ya_dsn_tmtbz -d dsn_tmtbz.mat -t 1var.con -n 500 --T2 -D 
Loading Data: 
Data loaded
7.96097e+53 permutations required for exhaustive test of t-test 1
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_ya_dsn_tmtbz_tfce_tstat1 is: 278281
7.96097e+53 permutations required for exhaustive test of t-test 2
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_ya_dsn_tmtbz_tfce_tstat2 is: 215024
Finished, exiting.
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_ya/stats/tbss_ya_dsn_tmtbz_tfce_corrp_tstat1.nii.gz', threshold = 0.90, title = 'YA slope > OA slope')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x1223a1510>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/cognition_17_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_ya/stats/tbss_ya_dsn_tmtbz_tfce_corrp_tstat2.nii.gz', threshold = 0.90, title = 'YA slope > OA slope')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x120781cd0>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/cognition_18_1.png)

</div>
</div>
</div>

