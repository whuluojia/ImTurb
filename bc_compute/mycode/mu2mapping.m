clc
close all
clear all



function mapping = mu2mapping(mu)
%% 输入：mu  贝尔特拉米系数
%% 输出：形变场

[H, W, C] = size(mapping);

[x,y] = meshgrid(1:H, 1:W);
vertex = [x(:),y(:),1+0*x(:)]; % 顶点 
face = delaunay(x(:),y(:));  % 三角格网剖分的三角形

gi = vertex(face(:, 0), 0);
gj = vertex(face(:, 1), 0);
gk = vertex(face(:, 2), 0);

hi = vertex(face(:, 0), 1);
hj = vertex(face(:, 1), 1);
hk = vertex(face(:, 2), 1);

gjgi = gj - gi;
gkgi = gk - gi;
hjhi = hj - hi;
hkhi = hk - hi;

area = (gjgi * hkhi - gkgi * hjhi) / 2;

gigk = -gkgi;
hihj = -hjhi;

mapping = mapping.view((N, C, -1));
mapping = mapping.permute(0, 2, 1);

si = mapping[:, face[:, 0], 0];
sj = mapping[:, face[:, 1], 0];
sk = mapping[:, face[:, 2], 0];

ti = mapping[:, face[:, 0], 1]
tj = mapping[:, face[:, 1], 1]
tk = mapping[:, face[:, 2], 1]

sjsi = sj - si
sksi = sk - si
tjti = tj - ti
tkti = tk - ti

a = (sjsi * hkhi + sksi * hihj) / area / 2;
b = (sjsi * gigk + sksi * gjgi) / area / 2;
c = (tjti * hkhi + tkti * hihj) / area / 2;
d = (tjti * gigk + tkti * gjgi) / area / 2;

down = (a+d)**2 + (c-b)**2 + 1e-8
up_real = (a**2 - d**2 + c**2 - b**2)
up_imag = 2*(a*b+c*d)
real = up_real / down
imag = up_imag / down

mu = torch.stack((real, imag), dim=1)


end


def bc_metric(mapping):
    """
    Inputs:
        mapping: (N, 2, h, w), torch tensor
    Outputs:
        mu: (N, 2, (h-1)*(w-1)*2), torch tensor
    """
    # The three input variables are pytorch tensors.
    N, C, H, W = mapping.shape
    device = mapping.device
    face, vertex = image_meshgen(H, W)
    face = torch.from_numpy(face).to(device=device)
    vertex = torch.from_numpy(vertex).to(device=device)

    gi = vertex[face[:, 0], 0]
    gj = vertex[face[:, 1], 0]
    gk = vertex[face[:, 2], 0]
    
    hi = vertex[face[:, 0], 1]
    hj = vertex[face[:, 1], 1]
    hk = vertex[face[:, 2], 1]
    
    gjgi = gj - gi
    gkgi = gk - gi
    hjhi = hj - hi
    hkhi = hk - hi
    
    area = (gjgi * hkhi - gkgi * hjhi) / 2

    gigk = -gkgi
    hihj = -hjhi

    mapping = mapping.view((N, C, -1))
    mapping = mapping.permute(0, 2, 1)

    si = mapping[:, face[:, 0], 0]
    sj = mapping[:, face[:, 1], 0]
    sk = mapping[:, face[:, 2], 0]
    
    ti = mapping[:, face[:, 0], 1]
    tj = mapping[:, face[:, 1], 1]
    tk = mapping[:, face[:, 2], 1]
    
    sjsi = sj - si
    sksi = sk - si
    tjti = tj - ti
    tkti = tk - ti
    
    a = (sjsi * hkhi + sksi * hihj) / area / 2;
    b = (sjsi * gigk + sksi * gjgi) / area / 2;
    c = (tjti * hkhi + tkti * hihj) / area / 2;
    d = (tjti * gigk + tkti * gjgi) / area / 2;
    
    down = (a+d)**2 + (c-b)**2 + 1e-8
    up_real = (a**2 - d**2 + c**2 - b**2)
    up_imag = 2*(a*b+c*d)
    real = up_real / down
    imag = up_imag / down

    mu = torch.stack((real, imag), dim=1)
    return mu